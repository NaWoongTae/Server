using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace ccharpEx
{
    enum Job { non, man, dog, fish }
    class Player
    {
        public Job job;
        public int level;
        public int hp;
        public int att;
    }

    class Man : Player
    {
        List<int> tem;
        public Man()
        {
            tem = new List<int>();
            job = Job.man;
        }
    }
    class Dog : Player
    { 
        public int bite { get => att * 2; }
        public Dog()
        {
            job = Job.dog;
        }
    }
    class Fish : Player
    {
        public int speed;
        public Fish()
        {
            speed = 20;
            job = Job.fish;
        }
    }

    class Playerjob
    {
        Random rand = new Random();

        public void Recruit()
        {
            List<Player> team = new List<Player>();

            for (int i = 0; i < 20; i++)
            {
                Job j = (Job)rand.Next(1, 4);

                Player p = j switch
                {
                    Job.man => new Man(),
                    Job.fish => new Fish(),
                    Job.dog => new Dog(),
                };

                // p.job = (Job)rand.Next(1, 4);
                p.level = rand.Next(0, 100);
                p.hp = rand.Next(1, 50);
                p.att = rand.Next(1, 20);

                team.Add(p);
            }

            {
                var tm2 = from p in team
                         where p.level > 50
                         orderby p.level
                         select p;

                var tm = team.Where(p => p is Dog)
                    .OrderBy(p => (p as Dog).bite)
                    .Select(p => p);

                foreach (Player p in tm)
                {
                    Console.WriteLine($"레벨 {p.level} : {p.job}");
                }
            }

            // =========================================

            {
                var byJob = from p in team
                            group p by p.job into g
                            orderby g.Key
                            select new { g.Key, Player = g };

            }

            // =========================================

            {
                List<int> lvl = new List<int>() { 1, 50, 99 };

                var same = from p in team
                           join i in lvl
                           on p.level equals i
                           select p;
            }
        }
    }
}
