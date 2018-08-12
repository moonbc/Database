//
//  DepartmentListVC.swift
//  Database
//
//  Created by 402-07 on 2018. 8. 5..
//  Copyright © 2018년 moonbc. All rights reserved.
//

import UIKit

class DepartmentListVC: UITableViewController {

    @IBAction func add(_ sender: Any) {
        
        let alert = UIAlertController(title: "부서 등록", message: "부서 정보를 입력하세요", preferredStyle: .alert)
        alert.addTextField(){
            (tf) in tf.placeholder="부서명"
        }
        alert.addTextField(){
            (tf) in tf.placeholder="주소"
        }
        
        //버튼 추가
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) {
            (_) in
            let title = alert.textFields![0].text
            let addr = alert.textFields![1].text
            
            //삽입하는 메소드 호출
            
            if self.departDAO.create(title: title!, addr: addr!) {
          
                //삽입에 성공하면 데이터를 다시 가져와서 테이블 뷰를 재출력
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: true)
        
    }
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    // 데이터 소스용 멤버 변수
    
    let departDAO = DepartmentDAO()
    // SQLite 처리를 담당할 DAO 객체
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.departList = departDAO.find()
        
        //화면 수정
        
        self.title = "부서목록"
        
        //왼쪽에 에디티 버튼 배치
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //셀을 드래그하면 편집모드가 되도록 설정
        
        self.tableView.allowsSelectionDuringEditing = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = departList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL", for: indexPath)

        cell.textLabel?.text = data.departTitle
        cell.detailTextLabel?.text = data.departAddr
        
        
        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
