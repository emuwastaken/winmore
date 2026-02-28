package emu.winmore.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

// Maps to each object in the top-level "cards" array
@JsonIgnoreProperties(ignoreUnknown = true)
public class ArchidektCardEntry {
    public int quantity;     // usually 1, can be >1 for basic lands
    public boolean companion;
    public ArchidektCard card;
    public List<String> categories;
}