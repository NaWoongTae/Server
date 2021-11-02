using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using HelloEmpty.Models;

namespace HelloEmpty.Pages
{
    public class IndexModel : PageModel
    {
        // 모델 바인딩 참가 암시
        [BindProperty]
        public HelloMessage HelloMsg { get; set; }

        public string Noti { get; set; }
        public void OnGet()
        {
            this.HelloMsg = new HelloMessage()
            {
                Message = "Hello Razor Cannon!!"
            };
        }

        public void OnPost()
        {
            this.Noti = "Message Changed";
        }
    }
}
