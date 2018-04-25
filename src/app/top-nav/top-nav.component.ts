import {Component, Input, OnInit} from '@angular/core';
import {Router} from '@angular/router';
@Component({
  selector: 'app-top-nav',
  templateUrl: './top-nav.component.html',
  styleUrls: ['./top-nav.component.scss']
})
export class TopNavComponent implements OnInit {
  constructor(private router: Router) { }
  ngOnInit() {
  }
    onLogOut() {
    localStorage.clear() ;
    window.location.reload();
    this.router.navigate(['auth']);
}
}
