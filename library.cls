public with sharing class library {
  

 @AuraEnabled(cacheable=true)
 public static List<Book__c> getbook() {
                
return      
 [SELECT Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c  ];
        
            }


 
 @AuraEnabled(cacheable=true)
 public static List<Borrow__c> getborrow() {
                
return      
 [SELECT Name , Book_ID__c  , Book_Name__c, Issue_Date__c  , Return_Date__c FROM  Borrow__c  ];
        
            }


            @AuraEnabled
 public static Book__c issuebook(List<Book__c> obj)
 {
     Book__c up = [select Issue_Date__c , Name , Book_Name__c ,Book_Status__c from Book__c where Name = : obj[0].Name  ];
     up.Book_Status__c = 'Borrowed';
     up.Issue_Date__c = system.today();
     update up;
    Borrow__c b = new Borrow__c(Book_ID__c = up.Name , Book_Name__c = up.Book_Name__c , Issue_Date__c = up.Issue_Date__c );
    insert b;
    return up;

 }


 @AuraEnabled
 public static Book__c returnbook(List<Borrow__c> obj)
 {
     Borrow__c up = [select Name , Book_ID__c  , Book_Name__c, Issue_Date__c  , Return_Date__c from Borrow__c where Name = : obj[0].Name  ];
     Book__c dd = [SELECT Name , Book_Name__c , Book_Status__c , Return_Date__c , Issue_Date__c FROM  Book__c where Name = : up.Book_ID__c ] ; 
     dd.Book_Status__c = 'Available';
     dd.Issue_Date__c = null;
     update dd;   
     delete up;
     return dd;

 }
 
 @AuraEnabled(cacheable=true)
    public static List<Book__c> getBookListByname(String param,String type){
    String key = '%' + type + '%';
    if (param=='Name') return [select Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c where Book_Name__c like :key];

    else if (param=='id') 
    return [select Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c where Name like : key];

    
    else if (param=='Author') return [select Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c where Author__c like :key];

    else if (param=='Category') return [select Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c where Category__c like :key];
    else return [select Name , Book_Name__c , Book_Status__c , Return_Date__c FROM  Book__c where Name like :''];
    }


 



}
