@isTest
public class TestUtilityTest {

    @isTest
    public static void TestClassForAss(){
        test.startTest();
        TestUtility.createAssignmentGroup('Name', true, 5, 5, 'New', 7, 8, 8);
        test.stopTest();
    }

    @isTest
    public Static Void TestClassForError(){
        test.startTest();
        TestUtility.CheckErrorMaster('Iphone','Apple', '250GB','Mobile', 'Black', 'This is a Good Phone','Good ram','New38',True,'Iphone13',11000);
        Test.stopTest();
    }
    @isTest
    Public Static Void TestClassForException(){
        Test.startTest();
        TestUtility.CreatException('Ajeet','Never Give Up','Health is Wealth');
        Test.stopTest();
    }
    @isTest
    Public Static void TesClassForFranchise(){
        Test.startTest();
        TestUtility.CreatingFranchise('Raviteja','3ASD54368NW','Ajeet','Bangalore','JP Nagar','560078','345343fjdjed','2019','india');
        Test.stopTest();
    }
    @isTest
    Public Static Void TestClassForUserTracking(){
        Test.startTest();
        TestUtility.CreatUserTracking(DateTime.newInstance(1999, 2, 11, 8, 6, 16));
        Test.stopTest();
            
    }
    @isTest
    Public Static Void TestClassForWarehouse(){
        Test.startTest();
        TestUtility.CreateWarehouse('Ravi Godwons','Bangalore','JP Nagar','560078','Karnataka','19th cross 5th main');
        Test.stopTest();
    }
    @isTest
    Public Static Void TestClassForShiftAss(){
        Test.startTest();
        TestUtility.ShiftAssignment('0052x000001Jke7AAC',34,'a252x0000004ws6AAA');
        Test.stopTest();
    }
    @isTest
    Public Static Void TestClassForAssGrpMbm(){
        Test.startTest();
        TestUtility.CreatAssnGroupMember(True,'a2N1m0000002HvJEAU',1,'0052x000001IrhnAAC',100,True);
        Test.stopTest();
    }
}