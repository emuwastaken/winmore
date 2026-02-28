package emu.winmore.model;

import java.util.List;

// Our clean internal card representation — stripped down from the raw Archidekt response
public class DeckCard {
    public String name;
    public String oracleText;
    public List<String> colorIdentity;
    public List<String> types;
    public double cmc;
    public int quantity;
}