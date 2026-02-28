package emu.winmore.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

// Maps to the "card" object inside each cards[] entry
// Just a thin wrapper — the real data is in oracleCard
@JsonIgnoreProperties(ignoreUnknown = true)
public class ArchidektCard {
    public OracleCard oracleCard;
}