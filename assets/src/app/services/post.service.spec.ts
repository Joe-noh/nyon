import { TestBed, inject, async } from '@angular/core/testing';
import { MockBackend, MockConnection } from '@angular/http/testing';
import {
  Http, Response, RequestMethod, ConnectionBackend,
  RequestOptions, BaseRequestOptions, ResponseOptions
} from '@angular/http';

import { PostService, Post } from './post.service';

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

  describe('fetchAll', () => {
    beforeEach(inject([ConnectionBackend], (mockBackend: MockBackend) => {
      mockBackend.connections.subscribe((connection: MockConnection) => {
        expect(connection.request.method).toEqual(RequestMethod.Get);

        connection.mockRespond(new Response(new ResponseOptions({
          status: 200,
          body: {
            posts: [{body: "hey"}, {body: "you"}]
          }
        })));
      });
    }));

    it('should return list of posts', async(inject([PostService], (service: PostService) => {
      service.fetchAll().subscribe((posts: Post[]) => {
        expect(posts[0].body).toEqual("hey");
        expect(posts[1].body).toEqual("you");
      });
    })));
  });

  describe('create', () => {
    beforeEach(inject([ConnectionBackend], (mockBackend: MockBackend) => {
      mockBackend.connections.subscribe((connection: MockConnection) => {
        expect(connection.request.method).toBe(RequestMethod.Post);

        const requestBody = connection.request.json();
        connection.mockRespond(new Response(new ResponseOptions({
          status: 201,
          body: {
            post: {body: requestBody["body"]}
          }
        })));
      });
    }));

    it('should return a post', async(inject([PostService], (service: PostService) => {
      service.create("hello").subscribe((post: Post) => {
        expect(post.body).toEqual("hello");
      });
    })));
  });
});