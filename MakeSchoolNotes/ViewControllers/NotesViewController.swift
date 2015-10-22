// done: Step 4: up to Creating Data

//  NotesViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Updated by Chris Orcutt on 09/07/2015.
//  Copyright © 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {
    
    var notes: Results <Note>!{
        didSet{
            //whenever notes update, udpate the table view
            tableView?.reloadData()
        }
    }
 
    var selectedNote: Note?
    
    override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    //let myNote = Note()
    //myNote.title = "Super Simple Test Note"
    //myNote.content = "A long piece of content"
    
    
    do {
        let realm = try Realm()
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
    } catch {
        print("handle error")
    }
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if let identifier = segue.identifier {
            do{
                let realm = try Realm()
                
                switch identifier{
                
                case "Save":
                    //
                    let source = segue.sourceViewController as! NewNoteViewController
                    try realm.write(){
                        realm.add(source.currentNote!)
                    }
                default:
                    print("No one loves \(identifier)")
                }
                //2
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
                
            } catch {
                print("Handle error")
            }
            
            
        }
    }
  
}

extension NotesViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
        let row = indexPath.row
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
}

extension NotesViewController{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //1
        selectedNote = notes[indexPath.row]
        // 2
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)
    }
    
    // 3
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 4
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let note = notes[indexPath.row] as Object
            
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.delete(note)
                }
                
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
            } catch {
                print("handle error")
            }
        }
    }
    
}
