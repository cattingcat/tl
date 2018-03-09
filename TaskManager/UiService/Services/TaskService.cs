using System.Collections.Generic;
using UiService.BusinessObjects;

namespace UiService.Services
{
    public class TaskService
    {
        private readonly Dictionary<int, Task> _tasks = new Dictionary<int, Task>();

        /// <summary>
        /// Создать таску
        /// </summary>
        /// <param name="task">Таска для создания</param>
        /// <returns>Созданная таска</returns>
        public Task Create(Task task)
        {
            if (task == null)
                return null;
            
            _tasks.TryAdd(task.Id, task);
            return task;
        }

        /// <summary>
        /// Получить по идентификатору
        /// </summary>
        /// <param name="id">Идентификатор</param>
        /// <returns>Таска</returns>
        public Task Get(int id)
        {
            if (id < 1)
                return null;

            _tasks.TryGetValue(id, out var task);
            return task;
        }

        /// <summary>
        /// Получить все элементы
        /// </summary>
        /// <returns>Внезапно! все элементы</returns>
        public IEnumerable<Task> GetAll()
        {
            return _tasks.Values;
        }

        /// <summary>
        /// Обновление объекта
        /// </summary>
        /// <param name="task">Обновляемая таска</param>
        /// <returns>Обновленная таска</returns>
        public Task Update(Task task)
        {
            if (task == null)
                return null;

            _tasks.Remove(task.Id);
            _tasks.TryAdd(task.Id, task);

            return task;
        }

        /// <summary>
        /// Удаление объекта
        /// </summary>
        /// <param name="id">Идентификатор объекта</param>
        public bool Delete(int id)
        {
            var isExist = _tasks.TryGetValue(id, out Task _);
            
            if (!isExist)
                return false;
            
            _tasks.Remove(id);
            return true;
        }
    }
}