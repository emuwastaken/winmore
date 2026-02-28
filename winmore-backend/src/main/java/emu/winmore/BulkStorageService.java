package emu.winmore;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;

@Service
public class BulkStorageService {

    Path dirPath = Path.of("bulk");
    Path bulkPath = Path.of("bulk/bulk_cards.json");
    Path metaPath = Path.of("bulk/bulk_meta.json");

    //Check the directory bulk exists
    private void validateDirectory(){

        //If not, create it
        if(!Files.exists(dirPath)){
            try {
                Files.createDirectories((dirPath));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        IO.println("Directory Validated");
    }

    //Check the bulk file exists
    private void validateBulk(){

        //If not, invoke scryfall and create a newfile with contents
        if(!Files.exists(bulkPath)){

            //Instantiate a client
            try {
                RestClient rc = RestClient.create();
                String metadata = rc
                        .get()
                        .uri("https://api.scryfall.com/bulk-data")
                        .header("User-Agent", "WinMore.cards/1.0")
                        .header("Accept", "application/json")
                        .retrieve()
                        .body(String.class);

                IO.println(metadata);

                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(metadata);
                JsonNode dataArray = root.get("data");


                String downloadUri = null;
                String updatedAt = null;
                for (JsonNode entry : dataArray) {
                    if ("oracle_cards".equals(entry.get("type").asText())) {
                        downloadUri = entry.get("download_uri").asText();
                        updatedAt = entry.get("updated_at").asText();
                        break;
                    }
                }

                if(updatedAt != null){
                    String meta = String.format("{\"updated_at\": \"%s\"}", updatedAt);
                    Files.writeString(metaPath, meta);
                }


                if (downloadUri == null) {
                    throw new RuntimeException("Could not find oracle_cards in Scryfall bulk-data response");
                } else {
                    IO.println("Fetching bulk at: " + downloadUri);
                }

                byte[] fileBytes = rc
                        .get()
                        .uri(downloadUri)
                        .header("User-Agent", "WinMore.cards/1.0")
                        .header("Accept", "application/json")
                        .retrieve()
                        .body(byte[].class);

                if(fileBytes != null)
                    Files.write(bulkPath, fileBytes);

            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            //Download the oracle cards from download link into bytestream
            IO.println("Bulk Fetched");
        }
        IO.println("Bulk Validated");
    }

    //Check for bulk updates
    private void validateVersion(){

        //If newer exists, delete old and fetch new
        if(Files.exists(metaPath)){
            try {
                //Read from file
                String meta = Files.readString(metaPath);
                ObjectMapper mapper = new ObjectMapper();
                JsonNode metaNode = mapper.readTree(meta);

                String localUpdatedAt = metaNode.get("updated_at").asText();
                OffsetDateTime localTime = OffsetDateTime.parse(localUpdatedAt);

                RestClient rc = RestClient.create();
                String metadata = rc
                        .get()
                        .uri("https://api.scryfall.com/bulk-data")
                        .header("User-Agent", "WinMore.cards/1.0")
                        .header("Accept", "application/json")
                        .retrieve()
                        .body(String.class);

                IO.println(metadata);

                JsonNode root = mapper.readTree(metadata);
                JsonNode dataArray = root.get("data");

                String scryfallUpdatedAt = null;
                for (JsonNode entry : dataArray) {
                    if ("oracle_cards".equals(entry.get("type").asText())) {
                        scryfallUpdatedAt = entry.get("updated_at").asText();
                        break;
                    }
                }

                assert scryfallUpdatedAt != null;
                OffsetDateTime scryfallTime = OffsetDateTime.parse(scryfallUpdatedAt);


                //Scryfall is newer, delete files and invoke validateBulk()
                if(scryfallTime.isAfter(localTime)){
                    IO.println("Scryfall has the newer version, re-fetching!");
                    Files.delete(bulkPath);
                    Files.delete(metaPath);
                    validateBulk();
                    IO.println("Version validated and completed with refetching!");
                    return;
                }

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        IO.println("Version validated and completed without refetching!");
    }

    @PostConstruct
    public void runService(){
        IO.println("Bulk Storage Service Invoked!");
        validateDirectory();
        validateBulk();
        validateVersion();
        IO.println("Bulk Storage Service Completed!");
    }
}
