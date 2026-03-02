package emu.winmore;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.node.ArrayNode;
import tools.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

@Service
public class BulkCuratorService {

    private static final Logger log = LoggerFactory.getLogger(BulkCuratorService.class);

    private static final Path BULK_PATH    = Path.of("bulk/bulk_cards.json");
    private static final Path STRIPPED_DIR = Path.of("bulk/stripped");
    private static final int  CHUNK_SIZE   = 100;

    private static final String[] KEEP_FIELDS = {
            "name",
            "oracle_text",
            "type_line",
            "cmc",
            "mana_cost",
            "color_identity",
            "keywords",
            "layout",
            "card_faces",
            "legalities"    // ++ ADDED: needed to filter by commander legality
    };

    @PostConstruct
    public void runService() {
        if (!Files.exists(BULK_PATH)) {
            log.warn("BulkCuratorService: bulk_cards.json not found, skipping curation.");
            return;
        }

        if (Files.exists(STRIPPED_DIR) && isAlreadyCurated()) {
            log.info("BulkCuratorService: stripped chunks already exist, skipping.");
            return;
        }

        log.info("BulkCuratorService: starting curation...");
        curate();
        log.info("BulkCuratorService: curation complete.");
    }

    private boolean isAlreadyCurated() {
        try {
            return Files.list(STRIPPED_DIR)
                    .anyMatch(p -> p.getFileName().toString().startsWith("chunk_"));
        } catch (IOException e) {
            return false;
        }
    }

    private void curate() {
        try {
            Files.createDirectories(STRIPPED_DIR);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(BULK_PATH.toFile());

            if (!root.isArray()) {
                log.error("BulkCuratorService: expected a JSON array at root, aborting.");
                return;
            }

            List<ObjectNode> stripped = new ArrayList<>();

            for (JsonNode card : root) {
                // Skip tokens, emblems, art cards
                String layout = card.path("layout").asText("");
                if (layout.equals("token") || layout.equals("emblem") || layout.equals("art_series")) {
                    continue;
                }

                // ++ ADDED: skip cards not legal in Commander
                String commanderLegality = card.path("legalities").path("commander").asText("");
                if (!"legal".equals(commanderLegality)) {
                    continue;
                }

                ObjectNode slim = mapper.createObjectNode();
                for (String field : KEEP_FIELDS) {
                    if (card.has(field)) {
                        slim.set(field, card.get(field));
                    }
                }
                stripped.add(slim);
            }

            log.info("BulkCuratorService: {} cards after filtering", stripped.size());

            int chunkIndex = 0;
            for (int i = 0; i < stripped.size(); i += CHUNK_SIZE) {
                int end = Math.min(i + CHUNK_SIZE, stripped.size());
                List<ObjectNode> chunk = stripped.subList(i, end);

                ArrayNode chunkArray = mapper.createArrayNode();
                chunk.forEach(chunkArray::add);

                String fileName = String.format("chunk_%03d.json", chunkIndex++);
                Path outPath = STRIPPED_DIR.resolve(fileName);
                mapper.writerWithDefaultPrettyPrinter().writeValue(outPath.toFile(), chunkArray);
            }

            log.info("BulkCuratorService: wrote {} chunk files to {}", chunkIndex, STRIPPED_DIR);

        } catch (IOException e) {
            log.error("BulkCuratorService failed: {}", e.getMessage());
            throw new RuntimeException(e);
        }
    }
}