import { TestBed, inject } from '@angular/core/testing';
import { MockBackend } from '@angular/http/testing';
import { Http, ConnectionBackend, RequestOptions, BaseRequestOptions } from '@angular/http';
import { PostService } from './post.service';

describe('PostService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        {provide: ConnectionBackend, useClass: MockBackend},
        {provide: RequestOptions, useClass: BaseRequestOptions},
        Http,
        PostService
      ]
    });
  });

  it('should be created', inject([PostService], (service: PostService) => {
    expect(service).toBeTruthy();
  }));
});
