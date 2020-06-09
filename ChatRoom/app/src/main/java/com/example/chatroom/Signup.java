package com.example.chatroom;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
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
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;


public class Signup extends AppCompatActivity {
    Button signUpButton;
    EditText signUpUsername, signUpPassword;
    TextView signInTextview;
    Intent logInIntent;
    String username, passsword;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        signUpUsername = (EditText) findViewById(R.id.usernameEditText);
        signUpPassword = (EditText) findViewById(R.id.passwordEditText);
        signInTextview = (TextView) findViewById(R.id.color);
        signUpButton = (Button) findViewById(R.id.signUpButton);

        logInIntent = new Intent(Signup.this, MainActivity.class);

        signInTextview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                startActivity(logInIntent);
            }
        });

        signUpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               username = signUpUsername.getText().toString();
               passsword = signUpPassword.getText().toString();

                String url = "http://165.22.14.77:8080/Anwesh/ChatRoom/Register.jsp?UserName="+username+"&Password="+passsword;
                RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
                StringRequest stringRequest = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response)
                    {
                        Log.e("Success", response);
                        if(response.contains("Registered successfully"))
                        {
                            Toast.makeText(Signup.this, "Registration success. Please login.",Toast.LENGTH_LONG).show();
                            startActivity(logInIntent);
                        }
                        else
                        {
                            Toast.makeText(Signup.this, response.toString(),Toast.LENGTH_LONG).show();
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error)
                    {
                        Toast.makeText(Signup.this,error.toString(),Toast.LENGTH_LONG).show();
                    }
                });
                queue.add(stringRequest);

            }
        });



    }
}