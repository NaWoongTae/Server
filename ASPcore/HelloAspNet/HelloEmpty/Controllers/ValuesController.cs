using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HelloEmpty.Models;

namespace HelloEmpty.Controllers
{
    // UI를 만들지 않고 데이터만 넘겨주고 니가 알아서 만들어라~

    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        [HttpGet]
        public List<HelloMessage> Get()
        {
            List<HelloMessage> messages = new List<HelloMessage>();
            messages.Add(new HelloMessage() { Message = "Hello Web Agumon!!"});
            messages.Add(new HelloMessage() { Message = "Hello Web Papimon!!" });
            messages.Add(new HelloMessage() { Message = "Hello Web Tentamon!!" });

            return messages;
        }
    }
}
