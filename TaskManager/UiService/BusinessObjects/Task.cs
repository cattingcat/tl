using System;

namespace UiService.BusinessObjects
{
    public class Task
    {
        public Guid Uuid { get; set; }

        public string Name { get; set; }

        public string Body { get; set; }
    }
}