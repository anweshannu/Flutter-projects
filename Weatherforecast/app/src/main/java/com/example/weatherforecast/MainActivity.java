package com.example.weatherforecast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.annotation.SuppressLint;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {


    String temp;
    String city;
    Button button, getButton, currentlocationbutton;
    EditText edittext;
    TextView textview;
    LocationManager locationManager;
    LocationListener listener;
    double longi, lati;
    String url;


    public boolean isConnected()
    {
        boolean connected = false;
        try
        {
            ConnectivityManager cm = (ConnectivityManager)getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo nInfo = cm.getActiveNetworkInfo();
            connected = nInfo != null && nInfo.isAvailable() && nInfo.isConnected();
            return connected;
        } catch (Exception e) {
            textview.setText("Connectivity Exception" + e.getMessage());
        }
        return connected;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getButton = (Button) findViewById(R.id.getButton);
        edittext = (EditText) findViewById(R.id.edittext);
        textview = (TextView)findViewById(R.id.textview);

        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 123);
        currentlocationbutton = (Button)findViewById(R.id.gpsbutton);
        locationManager = (LocationManager)getSystemService(LOCATION_SERVICE);
        listener = new LocationListener() {
            @Override
            public void onLocationChanged(Location location) {
                lati = location.getLatitude();
                longi = location.getLongitude();
            }

            @Override
            public void onStatusChanged(String provider, int status, Bundle extras) {
            }

            @Override
            public void onProviderEnabled(String provider) {
            }

            @Override
            public void onProviderDisabled(String provider) {
                Intent i = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                startActivity(i);
            }
        };
        configure_button();
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode){
            case 10:
                configure_button();
                break;
            default:
                break;
        }
    }

    void DisplayNoInternetConnectionMessage()
    {
        Toast.makeText(getApplicationContext(),"No Internet Connection.", Toast.LENGTH_SHORT).show();
        textview.setText("No Internet Connection.");
    }

    void configure_button(){
        // first check for permissions
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestPermissions(new String[]{Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.INTERNET}
                        ,10);
            }
            return;
        }
        // this code won't execute IF permissions are not allowed, because in the line above there is return statement.
        currentlocationbutton.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("MissingPermission")
            @Override
            public void onClick(View view) {
                //noinspection MissingPermission
                if(isConnected())
                {
                    locationManager.requestLocationUpdates("gps", 5000, 5000, listener);
                    url = "https://api.openweathermap.org/data/2.5/weather?lat="+lati+"&lon="+longi+"&units=metric&appid=251839045afcb2c38c6eba2d270899cd";
                    findTemperature(url, 'G');
                }
                else
                {
                    DisplayNoInternetConnectionMessage();
                }
            }

        });

        getButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //noinspection MissingPermission
            if(isConnected())
            {
                city = edittext.getText().toString();
                url = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&units=metric&APPID=251839045afcb2c38c6eba2d270899cd";
                findTemperature(url, 'N');
            }
            else
            {
                DisplayNoInternetConnectionMessage();
            }
            }
        });
    }
    void findTemperature(String url1, final char mode)
    {
        RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET,url1,null,new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response)
            {
                Log.e("Rest Response", response.toString());
                try
                {
                    JSONObject jsonObject;
                    city = response.getString("name");
                    jsonObject = response.getJSONObject("main");
                    temp = jsonObject.getString("temp");
                    if(mode == 'G')
                    {
                        if (city.contains("Globe"))
                        {
                            city = "your area";
                        }
                        else
                        {
                            city = "your area(" + city + ")";
                        }

                    }

                    textview.setText("Temperature in " + city + " is " + temp.toString() + "°C.");
                    Log.e("Temperature", temp);
                }
                catch (Exception e)
                {

                }
            } },
                new Response.ErrorListener()
                {
                    @Override
                    public void onErrorResponse(VolleyError error)
                    {
                        textview.setText("Please enter a valid city name.");
                        Log.e("Rest Response", error.toString());
                    }
                });
        requestQueue.add(jsonObjectRequest);
    }
}