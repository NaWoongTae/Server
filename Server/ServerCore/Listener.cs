using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Net.Sockets;

namespace ServerCore
{
    // _listenSocket.Accept() 블로킹 함수를
    // 비동기형식으로 변경한 클래스
    class Listener
    {
        Socket _listenSocket;
        Action<Socket> _onAcceptHandler;

        // 초기화
        public void Init(IPEndPoint endPoint, Action<Socket> onAcceptHandler)
        {
            _listenSocket = new Socket(endPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            _onAcceptHandler += onAcceptHandler;

            _listenSocket.Bind(endPoint);

            _listenSocket.Listen(10); // 최대 대기수

            SocketAsyncEventArgs args = new SocketAsyncEventArgs();
            args.Completed += new EventHandler<SocketAsyncEventArgs>(OnAcceptCompleted);
            RegisterAccept(args);
        }

        // 등록
        void RegisterAccept(SocketAsyncEventArgs args)
        {
            args.AcceptSocket = null;
            
            bool pending =_listenSocket.AcceptAsync(args);
            if (pending == false)   
                OnAcceptCompleted(null, args);            
        }

        void OnAcceptCompleted(object sender, SocketAsyncEventArgs args)
        {
            if (args.SocketError == SocketError.Success)
            {
                // TO DO
                _onAcceptHandler.Invoke(args.AcceptSocket);
            }
            else
                Console.WriteLine(args.SocketError.ToString());

            RegisterAccept(args);
        }

        public Socket Accept()
        {
            return _listenSocket.Accept();
        }
    }
}

