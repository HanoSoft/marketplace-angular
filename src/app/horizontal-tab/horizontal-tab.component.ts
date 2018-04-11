import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-horizontal-tab',
  templateUrl: './horizontal-tab.component.html',
  styleUrls: ['./horizontal-tab.component.scss']
})
export class HorizontalTabComponent implements OnInit {
@Input() description: string;
  constructor() { }

  ngOnInit() {
  }

}
