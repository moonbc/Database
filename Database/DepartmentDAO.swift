//
//  DepartmentDAO.swift
//  Database
//
//  Created by 402-07 on 2018. 8. 5..
//  Copyright © 2018년 moonbc. All rights reserved.
//

import UIKit

class DepartmentDAO {
    
    //데이터를 삽입하는 메소드
    func create(title: String!, addr:String!) -> Bool {
        
        let sql = """
            insert into department(dept_title, dept_addr) values(?,?)

        """
        
        try! self.fmdb.executeUpdate(sql, values: [title!, addr!])
        
        
        return true
    }
    
    func delete(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE dept_cd= ? "
            try self.fmdb.executeUpdate(sql, values: [departCd])
            return true
        } catch let error as NSError {
            print("DELETE Error : \(error.localizedDescription)")
            return false
        }
    }

    
    //부서 테이블의 테이터를 저장할 튜플의 별명을 생성
    typealias DepartRecord = (Int, String, String)
    
    
    //데이터베이스 객체를 만들기 - 지연생성
    //지연생성 - 처음에는 만들지 않고 처음 사용될 때는 만드는 것
    

    
    // SQLite 연결 및 초기화
    lazy var fmdb : FMDatabase! = {
        // 1. 파일 매니저 객체를 생성
        let fileMgr = FileManager.default
        // 2. 샌드박스 내 문서 디렉터리에서 데이터베이스 파일 경로를 확인
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        // 3. 샌드박스 경로에 파일이 없다면 메인 번들에 만들어 둔 hr.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        // 4. 준비된 데이터베이스 파일을 바탕으로 FMDatabase 객체를 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()

    
    
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
    
    //department 테이블의 테이터 전체를 읽어서 리턴하는 메소드
    func find() -> [DepartRecord] {
        var departList = [DepartRecord]()
        do {
            let sql = """
        SELECT dept_cd, dept_title, dept_addr
        FROM department
        ORDER BY dept_cd ASC
      """
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            // 2. 결과 집합 추출
            while rs.next() {
                let departCd = rs.int(forColumn: "dept_cd")
                let departTitle = rs.string(forColumn: "dept_title")
                let departAddr = rs.string(forColumn: "dept_addr")
                // append 메소드 호출 시 아래 튜플을 괄호 없이 사용하지 않도록 주의
                departList.append( ( Int(departCd), departTitle!, departAddr! ) )
            }
        }catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }

        
        
        return departList
    }
    
    func get(departCd: Int) -> DepartRecord? {
        // 1. 질의 실행
        let sql = """
      SELECT dept_cd, dept_title, dept_addr
      FROM department
      WHERE dept_cd = ?
    """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        // 결과 집합 처리
        if let _rs = rs { // 결과 집합이 옵셔널 타입으로 반환되므로, 이를 일반 상수에 바인딩하여 해제한다.
            _rs.next()
            let departId = _rs.int(forColumn: "dept_cd")
            let departTitle = _rs.string(forColumn: "dept_title")
            let departAddr = _rs.string(forColumn: "dept_addr")
            return (Int(departId), departTitle!, departAddr!)
        } else { // 결과 집합이 없을 경우 nil을 반환한다.
            return nil
        }
    }
    

}
