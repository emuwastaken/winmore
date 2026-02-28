package emu.winmore;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class AnalyzeController {

    private static final Logger log = LoggerFactory.getLogger(AnalyzeController.class);

    private final DeckFetcherService deckFetcherService;

    public AnalyzeController(DeckFetcherService deckFetcherService) {
        this.deckFetcherService = deckFetcherService;
    }

    @PostMapping("/analyze")
    public ResponseEntity<?> analyze(@RequestBody AnalyzeRequest request) {
        log.info("Received analyze request for URL: {}", request.url);

        DeckFetcherService.DeckFetchResult result = deckFetcherService.fetchDeck(request.url);

        if (!result.ok) {
            return ResponseEntity.badRequest().body(new ErrorResponse(result.error));
        }

        return ResponseEntity.ok(result);
    }

    public static class AnalyzeRequest {
        public String url;
    }

    public static class ErrorResponse {
        public String error;
        public ErrorResponse(String error) { this.error = error; }
    }
}