package emu.winmore;

import com.fasterxml.jackson.databind.ObjectMapper;
import emu.winmore.model.ArchidektCardEntry;
import emu.winmore.model.ArchidektDeckResponse;
import emu.winmore.model.DeckCard;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.ArrayList;
import java.util.List;

@Service
public class DeckFetcherService {


    public static class DeckFetchResult {
        public final boolean ok;
        public final String error;
        public final String deckName;
        public final List<DeckCard> cards;

        private DeckFetchResult(boolean ok, String error, String deckName, List<DeckCard> cards) {
            this.ok = ok;
            this.error = error;
            this.deckName = deckName;
            this.cards = cards;
        }

        public static DeckFetchResult success(String deckName, List<DeckCard> cards) {
            return new DeckFetchResult(true, null, deckName, cards);
        }

        public static DeckFetchResult error(String message) {
            return new DeckFetchResult(false, message, null, null);
        }
    }


    private static final Logger log = LoggerFactory.getLogger(DeckFetcherService.class);
    private static final int COMMANDER_FORMAT = 3;
    private static final int REQUIRED_CARD_COUNT = 100;

    // ++ ADDED: category name to filter out
    private static final String MAYBEBOARD_CATEGORY = "Maybeboard";

    private final RestClient restClient = RestClient.create();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public DeckFetchResult fetchDeck(String url) {
        if (url.contains("archidekt.com")) {
            return fetchArchidekt(url);
        }
        return DeckFetchResult.error("Unrecognised URL. Please provide an Archidekt deck link.");
    }

    private DeckFetchResult fetchArchidekt(String url) {
        try {
            String code = extractArchidektId(url);
            if (code == null) {
                return DeckFetchResult.error("Unrecognised URL. Please provide an Archidekt deck link.");
            }

            String apiUrl = "https://archidekt.com/api/decks/" + code + "/";
            String result = restClient
                    .get()
                    .uri(apiUrl)
                    .header("User-Agent", "WinMore.cards/1.0")
                    .header("Accept", "application/json")
                    .retrieve()
                    .body(String.class);

            ArchidektDeckResponse deck = objectMapper.readValue(result, ArchidektDeckResponse.class);

            if (deck.deckFormat != COMMANDER_FORMAT) {
                return DeckFetchResult.error("This deck is not a Commander deck.");
            }
            if (deck.isPrivate) {
                return DeckFetchResult.error("This deck is private. Make it public on Archidekt and try again.");
            }

            List<DeckCard> cards = new ArrayList<>();
            int totalCards = 0;

            for (ArchidektCardEntry entry : deck.cards) {
                if (entry.card == null || entry.card.oracleCard == null) continue;

                // ++ ADDED: skip maybeboard cards
                if (entry.categories != null && entry.categories.contains(MAYBEBOARD_CATEGORY)) continue;

                totalCards += entry.quantity;
                DeckCard card = new DeckCard();
                card.name = entry.card.oracleCard.name;
                card.oracleText = entry.card.oracleCard.text;
                card.colorIdentity = entry.card.oracleCard.colorIdentity;
                card.types = entry.card.oracleCard.types;
                card.cmc = entry.card.oracleCard.cmc;
                card.quantity = entry.quantity;
                cards.add(card);
            }

            if (totalCards != REQUIRED_CARD_COUNT) {
                return DeckFetchResult.error("Deck has " + totalCards + " cards — must be exactly 100.");
            }

            return DeckFetchResult.success(deck.name, cards);

        } catch (Exception e) {
            log.error("Failed to fetch Archidekt deck: {}", e.getMessage());
            return DeckFetchResult.error("Failed to reach Archidekt. Please try again later.");
        }
    }

    private String extractArchidektId(String url) {
        String[] parts = url.split("/");
        for (int i = 0; i < parts.length; i++) {
            if (parts[i].equals("decks") && i + 1 < parts.length) {
                return parts[i + 1];
            }
        }
        return null;
    }

}