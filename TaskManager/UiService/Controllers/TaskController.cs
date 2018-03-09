using Microsoft.AspNetCore.Mvc;
using UiService.BusinessObjects;
using UiService.Services;

namespace UiService.Controllers
{
    [Route("api/[controller]")]
    public class TaskController
    {
        private readonly TaskService _taskService;

        public TaskController(TaskService taskService)
        {
            _taskService = taskService;
        }

        [HttpGet(nameof(GetAll))]
        public IActionResult GetAll()
        {
            return new OkObjectResult(_taskService.GetAll());
        }
        
        [HttpGet("{id}", Name = nameof(Get))]
        public IActionResult Get([FromQuery] int id)
        {
            var task = _taskService.Get(id);
            
            if (task == null)
                return new NotFoundResult();
            
            return new OkObjectResult(task);
        }

        [HttpPost(nameof(Update))]
        public IActionResult Update([FromBody] Task task)
        {
            var updatedTask = _taskService.Update(task);

            if (updatedTask == null)
                return new BadRequestResult();

            return new OkObjectResult(updatedTask);
        }

        [HttpPut(nameof(Create))]
        public IActionResult Create([FromBody] Task task)
        {
            return new OkObjectResult(_taskService.Create(task));
        }

        [HttpDelete("{id}", Name = nameof(Delete))]
        public IActionResult Delete([FromQuery] int id)
        {
            var status = _taskService.Delete(id);

            return new OkObjectResult(status);
        }
    }
}