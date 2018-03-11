import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/task_list_component/utils/view_model_mapper.dart';
import 'package:test/test.dart';


void main() {
  group('ViewModelMapper tests', () {
    test('#buildSkeleton()', () {
      final mapper = new ViewModelMapper();

      final tree = new LinkedTree<TaskListModel>();
      final m1 = new TaskModel('m1');
      final m2 = new TaskModel('m2');
      final m3 = new TaskModel('m3');
      final m4 = new TaskModel('m4');
      final m5 = new TaskModel('m5');

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);

      final sublistVm = mapper.buildSkeleton(m4).viewModel;

      expect(sublistVm.headerModel, isNull, reason: 'root node without VM');
      expect(sublistVm.sublist, hasLength(1));

      final m1Vm = sublistVm.sublist.first;
      expect(m1Vm.headerModel.model, m1);

      final m2Vm = m1Vm.sublist.first;
      expect(m2Vm.headerModel.model, m2);

      final m3Vm = m2Vm.sublist.first;
      expect(m3Vm.headerModel.model, m3);

      final m4Vm = m3Vm.sublist.first;
      expect(m4Vm.headerModel.model, m4);
      expect(m4Vm.sublist, isEmpty);
    });

    test('#buildSkeleton() shoud return correct mapping', () {
      final mapper = new ViewModelMapper();

      final tree = new LinkedTree<TaskListModel>();
      final m1 = new TaskModel('m1');
      final m2 = new TaskModel('m2');
      final m3 = new TaskModel('m3');
      final m4 = new TaskModel('m4');
      final m5 = new TaskModel('m5');

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);

      final mapping = mapper.buildSkeleton(m4).modelsMap;

      expect(mapping.keys, unorderedEquals([m1, m2, m3, m4, null]));
    });

    test('Should map sublist of modelt to hierarchical view model', () {
      final mapper = new ViewModelMapper();

      final tree = new LinkedTree<TaskListModel>();
      final m1 = new TaskModel('m1');
      final m2 = new TaskModel('m2');
      final m3 = new TaskModel('m3');
      final m4 = new TaskModel('m4');
      final m5 = new TaskModel('m5');
      final m6 = new TaskModel('m6');
      final m7 = new TaskModel('m7');
      final m8 = new TaskModel('m8');

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);

      final sublistToShow = [m3, m4, m5, m6, m7];

      final skeleton = mapper.buildSkeleton(m3);
      expect(skeleton.modelsMap.keys, contains(m2));
      expect(skeleton.modelsMap.keys, contains(m1));


      final sublistVm = mapper.map2(sublistToShow);

      expect(sublistVm.headerModel, isNull, reason: 'root node without VM');
      expect(sublistVm.showHeader, isFalse, reason: 'root always invisible');
      expect(sublistVm.sublist, hasLength(1));


    });
  });

}