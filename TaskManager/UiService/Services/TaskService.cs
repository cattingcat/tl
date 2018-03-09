using System.Collections.Generic;
using UiService.BusinessObjects;

namespace UiService.Services
{
    public class TaskService
    {
        private Dictionary<int, Task> Tasks = new Dictionary<int, Task>();

        /// <summary>
        /// Создать таску
        /// </summary>
        /// <param name="task">Таска для создания</param>
        /// <returns>Созданная таска</returns>
        public Task Create(Task task)
        {
            if (task == null)
                return null;
            
            Tasks.TryAdd(task.Id, task);
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

            Tasks.TryGetValue(id, out var task);
            return task;
        }

        /// <summary>
        /// Получить все элементы
        /// </summary>
        /// <returns>Внезапно! все элементы</returns>
        public IEnumerable<Task> GetAll()
        {
            return Tasks.Values;
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

            Tasks.Remove(task.Id);
            Tasks.TryAdd(task.Id, task);

            return task;
        }

        /// <summary>
        /// Удаление объекта
        /// </summary>
        /// <param name="id">Идентификатор объекта</param>
        public bool Delete(int id)
        {
            var isExist = Tasks.TryGetValue(id, out Task _);
            
            if (!isExist)
                return false;
            
            Tasks.Remove(id);
            return true;
        }
    }
}