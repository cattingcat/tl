using System;
using System.Collections.Generic;
using UiService.BusinessObjects;

namespace UiService.Services
{
    public class TaskService
    {
        private readonly Dictionary<Guid, Task> _tasks = new Dictionary<Guid, Task>();

        /// <summary>
        /// Создать таску
        /// </summary>
        /// <param name="task">Таска для создания</param>
        /// <returns>Созданная таска</returns>
        public Task Create(Task task)
        {
            if (task == null)
                return null;

            if (Guid.Empty == task.Uuid)
                task.Uuid = Guid.NewGuid();
            
            _tasks.TryAdd(task.Uuid, task);
            return task;
        }

        /// <summary>
        /// Получить по идентификатору
        /// </summary>
        /// <param name="uuid">Идентификатор</param>
        /// <returns>Таска</returns>
        public Task Get(Guid uuid)
        {
            if (Guid.Empty == uuid)
                return null;

            _tasks.TryGetValue(uuid, out var task);
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

            _tasks.Remove(task.Uuid);
            _tasks.TryAdd(task.Uuid, task);

            return task;
        }

        /// <summary>
        /// Удаление объекта
        /// </summary>
        /// <param name="uuid">Идентификатор объекта</param>
        public bool Delete(Guid uuid)
        {
            var isExist = _tasks.TryGetValue(uuid, out Task _);
            
            if (!isExist)
                return false;
            
            _tasks.Remove(uuid);
            return true;
        }
    }
}