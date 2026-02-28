package emu.winmore.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

// Maps to the full JSON response from https://archidekt.com/api/decks/{id}/
@JsonIgnoreProperties(ignoreUnknown = true)
public class ArchidektDeckResponse {
    public int id;
    public String name;
    public int deckFormat;           // 3 = Commander
    @JsonProperty("private")
    public boolean isPrivate;        // "private" is a reserved word, needs @JsonProperty
    public List<ArchidektCardEntry> cards;
}