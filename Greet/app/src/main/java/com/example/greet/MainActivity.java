package com.example.greet;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.telecom.TelecomManager;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Button Btn = (Button) findViewById(R.id.Btn);
        final EditText textbox = (EditText) findViewById(R.id.textbox);
        final TextView display = (TextView) findViewById(R.id.display);
        Btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String message = "Hi " + textbox.getText().toString() + "!";
                Toast toast = Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT);
                toast.show();
                display.setText(message);
            }

    });
    }
}