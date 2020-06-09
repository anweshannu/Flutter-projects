package com.example.chatroom;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
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

public class MainActivity extends AppCompatActivity {

    Button loginButton;
    TextView signUpTextView;
    EditText usernameEditText, passwordEditText;
    Intent signUpIntent, chatRoomIntent;
    String loginUserName, loginPassword;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        signUpTextView = (TextView) findViewById(R.id.color);
        loginButton = (Button) findViewById(R.id.signUpButton);
        usernameEditText = (EditText) findViewById(R.id.usernameEditText);
        passwordEditText = (EditText) findViewById(R.id.passwordEditText);


        signUpTextView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                signUpIntent = new Intent(MainActivity.this, Signup.class);
                startActivity(signUpIntent);
            }
        });

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isConnected())
                {

                    loginUserName = usernameEditText.getText().toString();
                    loginPassword = passwordEditText.getText().toString();



                    String url = "http://165.22.14.77:8080/Anwesh/ChatRoom/Login.jsp?UserName="+loginUserName+"&Password="+loginPassword;
                    RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
                    StringRequest stringRequest = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response)
                        {
                            Log.e("Success", response);
                            if(response.contains("Success"))
                            {
                                Toast.makeText(getApplicationContext(),"Login successful.", Toast.LENGTH_SHORT).show();
                               chatRoomIntent = new Intent(MainActivity.this, ChatWindow.class);
                               chatRoomIntent.putExtra("username", loginUserName);
                               startActivity(chatRoomIntent);

                            }
                            else
                            {
                                Toast.makeText(MainActivity.this,"Invalid username or password.",Toast.LENGTH_LONG).show();
                            }
                        }
                    }, new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error)
                        {
                            Toast.makeText(MainActivity.this,error.toString(),Toast.LENGTH_LONG).show();
                        }
                    });
                    queue.add(stringRequest);

                }
                else
                {
                    Toast.makeText(getApplicationContext(),"No internet connection.", Toast.LENGTH_SHORT).show();
                }

            }
        });




    }

    public boolean isConnected()
    {
        boolean connected = false;
        try
        {
            ConnectivityManager cM = (ConnectivityManager)getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo nInfo = cM.getActiveNetworkInfo();
            connected = nInfo != null && nInfo.isAvailable() && nInfo.isConnected();
            return connected;
        }
        catch (Exception e)
        {
            Toast.makeText(getApplicationContext(), "No internet Connection",Toast.LENGTH_SHORT).show();
        }
        return connected;
    }




}