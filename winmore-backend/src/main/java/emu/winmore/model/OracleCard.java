package emu.winmore.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;

// Maps to the "oracleCard" object nested inside card
@JsonIgnoreProperties(ignoreUnknown = true)
public class OracleCard {
    public String name;
    public String text;
    public List<String> colorIdentity;
    public List<String> types;
    public double cmc;
    public String manaCost;
    public String layout;
    public List<Object> faces; // populated for MDFCs and transform cards
}