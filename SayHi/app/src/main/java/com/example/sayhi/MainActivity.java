package com.example.sayhi;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    Button hi_Button;
    EditText input_TextBox;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        hi_Button = (Button) findViewById(R.id.hiButton);
        hi_Button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                input_TextBox = (EditText) findViewById(R.id.inputTextBox);
                Context textContent = getApplicationContext();
                CharSequence text = "Hi " + input_TextBox.getText().toString() + "!";
                int duration = Toast.LENGTH_SHORT;
                Toast toast = Toast.makeText(textContent, text, duration);
                toast.show();

            }
        }
        );


    }

}

