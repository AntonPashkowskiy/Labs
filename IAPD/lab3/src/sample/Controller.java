package sample;

import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.ProgressBar;

public class Controller {
    @FXML private Label capacityLabel = new Label();
    @FXML private ProgressBar capacityProgressBar = new ProgressBar();
    @FXML private ListView<String> listOfProperties = new ListView<String>();

    private ObservableList<String> batteryProperies = null;
    private Battery battery = new Battery();
    private Thread backgroundThread;

    @FXML
    public void initialize() {
        batteryProperies = FXCollections.observableArrayList();
        listOfProperties.setItems(batteryProperies);
        updateInformation();

        backgroundThread = new Thread(this::startUpdateCycle);
        // daemon thread terminates when the main thread terminates
        backgroundThread.setDaemon(true);
        backgroundThread.start();
    }

    private void startUpdateCycle() {
        while(true) {
            try {
                Thread.sleep(1000);
                Platform.runLater(this::updateInformation);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private void updateInformation() {
        battery.updateInformation();
        batteryProperies.clear();

        batteryProperies.add("Manufacturer: " + battery.getManufacturer());
        batteryProperies.add("Type: " + battery.getType());
        batteryProperies.add("Technology: " + battery.getTechnology());
        batteryProperies.add("Status: " + battery.getStatus());
        batteryProperies.add("Charge full: " + (battery.getChargeFull() / 1000) + " MAh");
        batteryProperies.add("Charge now: " + (battery.getChargeNow() / 1000) + " MAh");

        capacityLabel.setText(String.valueOf(battery.getCapacity()) + " %");
        capacityProgressBar.setProgress((double)battery.getCapacity() / 100.0);
    }
}
