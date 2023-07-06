import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Widget CustomHtmlWidget(String content) => HtmlWidget(
      content,
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'table':
            return {
              'text-align': 'center',
              'border': '1px solid grey',
              'border-collapse': 'collapse',
            };
          case 'td':
            return {
              'font-size': '12px',
              'text-align': 'center',
              'border': '1px solid grey',
            };
          case 'th':
            return {
              'text-align': 'center',
              'border': '1px solid grey',
            };
          case 'div':
            return {
              'text-align': 'center',
              'margin': '0px',
            };
        }
        return null;
      },
    );
