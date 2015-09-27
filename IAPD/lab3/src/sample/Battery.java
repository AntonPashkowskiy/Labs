package sample;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import static java.lang.Integer.*;

public class Battery {
    private String manufacturer;
    private String technology;
    private String type;
    private String status;
    private int capacity;
    private int chargeFull;
    private int chargeNow;

    public Battery() {
        updateInformation();
    }

    public String getManufacturer() {
        return manufacturer == null ? "" : manufacturer;
    }

    public String getTechnology() {
        return technology == null ? "" : technology;
    }

    public String getType() {
        return type == null ? "" : type;
    }

    public String getStatus() {
        return status == null ? "" : status;
    }

    public int getCapacity() {
        return capacity;
    }

    public int getChargeFull() {
        return chargeFull;
    }

    public int getChargeNow() {
        return chargeNow;
    }

    public void updateInformation() {
        manufacturer = getLineFromFile("/sys/class/power_supply/BAT0/manufacturer");
        technology = getLineFromFile("/sys/class/power_supply/BAT0/technology");
        status = getLineFromFile("/sys/class/power_supply/BAT0/status");
        type = getLineFromFile("/sys/class/power_supply/BAT0/type");
        String capacityValue = getLineFromFile("/sys/class/power_supply/BAT0/capacity");
        String chargeFullValue = getLineFromFile("/sys/class/power_supply/BAT0/charge_full");
        String chargeNowValue = getLineFromFile("/sys/class/power_supply/BAT0/charge_now");

        capacityValue = capacityValue == null ? "0" : capacityValue;
        chargeFullValue = chargeFullValue == null ? "0" : chargeFullValue;
        chargeNowValue = chargeNowValue == null ? "0" : chargeNowValue;

        capacity = Integer.valueOf(capacityValue);
        chargeFull = Integer.valueOf(chargeFullValue);
        chargeNow = Integer.valueOf(chargeNowValue);
    }

    private String getLineFromFile(String path) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(path));
            String result = reader.readLine();
            reader.close();

            return result;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
