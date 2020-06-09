package com.example.chatroom;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
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

import org.w3c.dom.Text;

public class ChatWindow extends AppCompatActivity {

    TextView activeUsersTextView, chatBoxTextView;
    EditText userMessageEditText;
    Button sendButton, signOutButton;
    String username, activeUsers, userMessage;
    Thread activeUsersThread, getMessagesThread;
    boolean activeState = true;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_window);
        activeState = true;

        activeUsersTextView = (TextView) findViewById(R.id.activeUsersTextView);
        chatBoxTextView = (TextView) findViewById(R.id.chatBoxTextView);
        userMessageEditText = (EditText) findViewById(R.id.messageEditText);
        sendButton = (Button) findViewById(R.id.sendButton);
        signOutButton = (Button) findViewById(R.id.signOutButton) ;

        Intent intent2 = getIntent();
        username = intent2.getStringExtra("username");
        Toast.makeText(getApplicationContext(), username,Toast.LENGTH_SHORT);

        runActiveUsersThread();
        runGetMessagesThread();



        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                userMessage = userMessageEditText.getText().toString();
                if(userMessage.length() > 0)
                {
                    sendMessage(userMessage);
                }

            }
        });

        signOutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                activeState = false;
                Toast.makeText(ChatWindow.this,"Signed out successfully.",Toast.LENGTH_SHORT).show();
                startActivity(new Intent(ChatWindow.this,MainActivity.class));
            }
        });

    }

    void runActiveUsersThread()
    {
        activeUsersThread = new Thread( new Runnable() { @Override public void run() {
          while (activeState) {

                Context context = getApplicationContext();
                String url = "http://165.22.14.77:8080/Anwesh/ChatRoom/GetActiveUsersData.jsp?UserName=" + username;
                RequestQueue queue = Volley.newRequestQueue(context);
                StringRequest request = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        activeUsers = response.replaceAll("<br>", "").trim();
                        activeUsersTextView.setText(activeUsers.replace("&#8226;"," ●"));
                        activeUsersTextView.setMovementMethod(new ScrollingMovementMethod());
                        Log.e("Messages", response);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.e("error", error.toString());
                    }
                });
                queue.add(request);
                try
                {
                    Thread.sleep(3000);
                }
                catch (InterruptedException e)
                {
                    e.printStackTrace();
                    break;
                }
            }
        } } );
        activeUsersThread.start();
    }

    void runGetMessagesThread()
    {
        getMessagesThread = new Thread( new Runnable() { @Override public void run() {
        while (activeState)
        {
                String url = "http://165.22.14.77:8080/Anwesh/ChatRoom/GetMessage.jsp?UserName=" + username;
                RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
                StringRequest request = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                        chatBoxTextView.setText(response.replaceAll("<br>", "").trim().replaceAll(username + ": ", "You: "));
                        chatBoxTextView.setMovementMethod(new ScrollingMovementMethod());
                        Log.e("Messages", response);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.e("error", error.toString());
                    }
                });
                queue.add(request);
                try
                {
                    Thread.sleep(3000);
                }
                catch (InterruptedException e)
                {
                    e.printStackTrace();
                    break;
                }
            }
        } } );
        getMessagesThread.start();
    }

    void sendMessage(String userMessage)
    {
        String url = "http://165.22.14.77:8080/Anwesh/ChatRoom/SendMessage.jsp?UserName=" + username+ "&Message=" + userMessage;
        RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
        StringRequest request = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.e("Messages", response);
                if(response.toString().contains("Sent"))
                {
                    userMessageEditText.setText("");
                }
                else
                {
                    Toast.makeText(getApplicationContext(),"Message not sent.", Toast.LENGTH_SHORT).show();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("error", error.toString());
            }
        });
        queue.add(request);
    }
    public void onDestroy()
    {
        super.onDestroy();
        activeUsersThread.interrupt();
        getMessagesThread.interrupt();
    }
    public void onBackPressed() {
//        thread.destroy();
        activeUsersThread.interrupt();
        getMessagesThread.interrupt();
        super.onBackPressed();
    }
}