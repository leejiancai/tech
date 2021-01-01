[TOC]

# HTTP协议的一些概念

HTTP协议包括：HTTP/0.9 、HTTP/1.0 、HTTP/1.1和HTTP/2

- HTTP/0.9只有GET方法，基本没人用了，作为背景了解即可
- HTTP/1.0目前还有大量在使用，存在问题：HTTP请求没有keepalive的机制、没有Upgrade的机制
- HTTP/1.1后，默认的HTTP请求都是keepalive的，所谓keepalive就是一次tcp握手连接建立后，此tcp请求可以串行多个HTTP请求和响应。另外websocket等基于HTTP/1.1的协议也是需要Upgrade的机制的
- HTTP/2后，就支持多个stream了，真正的多路复用。

# 基本元素

- message： 一个请求或响应都叫做一个message。message包括：start-line（request-line或status-line）、headers、An empty line 、Optional HTTP body

- 一个request的message的例子：

  ```http
  POST /cgi-bin/process.cgi HTTP/1.1
  User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
  Host: www.tutorialspoint.com
  Content-Type: application/x-www-form-urlencoded
  Content-Length: length
  Accept-Language: en-us
  Accept-Encoding: gzip, deflate
  Connection: Keep-Alive
  
  licenseID=string&content=string&/paramsXML=string
  ```

  

- 一个response的message例子：

   ```http
  HTTP/1.1 200 OK
  Date: Sun, 10 Oct 2010 23:26:07 GMT
  Server: Apache/2.2.8 (Ubuntu) mod_ssl/2.2.8 OpenSSL/0.9.8g
  Last-Modified: Sun, 26 Sep 2010 22:04:35 GMT
  ETag: "45b6-834-49130cc1182c0"
  Accept-Ranges: bytes
  Content-Length: 12
  Connection: close
  Content-Type: text/html
  
  Hello world!
   ```

  

