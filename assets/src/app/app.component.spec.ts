import { TestBed, async } from '@angular/core/testing';
import { MockBackend } from '@angular/http/testing';

import { Http, ConnectionBackend, RequestOptions, BaseRequestOptions } from '@angular/http';
import { AppComponent } from './app.component';
import { PostService } from './services/post.service';

describe('AppComponent', () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [
        AppComponent
      ],
      providers: [
        {provide: ConnectionBackend, useClass: MockBackend},
        {provide: RequestOptions, useClass: BaseRequestOptions},
        Http,
        PostService
      ]
    }).compileComponents();
  }));

  it('should create the app', async(() => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.debugElement.componentInstance;

    expect(app).toBeTruthy();
  }));
});
