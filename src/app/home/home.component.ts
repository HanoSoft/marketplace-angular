import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
    @Input()  name: string ;
    @Input()  description: string ;
  constructor() { }

  ngOnInit() {
  }

}
