use axum::{Router, routing::get, Json, response::IntoResponse};
use reqwest::get as reqwest_get;
use serde::{Serialize, Deserialize};
use sqlx::{MySqlPool, Error, prelude::FromRow};

#[derive(Serialize)]
pub struct Data {
    message: String,
    username: String
}

#[derive(FromRow, Serialize, Deserialize, Debug)]
pub struct User {
    id: i32,
    name: String,
    age: i32
}

#[tokio::main]
async fn main() {
    let app = Router::new()
    .route("/hello_world", get(hello_world))
    .route("/httpbin", get(httpbin))
    .route("/get_json", get(get_json))
    .route("/get_users", get(get_all_users));

    axum::Server::bind(&"0.0.0.0:3000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn hello_world() -> String {
    "Hello world!".to_owned()
}

async fn httpbin() -> String {
    let response = reqwest_get("https://httpbin.org/get").await.unwrap();
    response.text().await.unwrap()
}

async fn get_json() -> Json<Data> {
    let data = Data {
        message: "test".to_string(),
        username: "admin".to_string(),
    };

    Json(data)
}

async fn get_all_users() -> impl IntoResponse {
    let pool = connect().await.unwrap();

    let res: Vec<User> = sqlx::query_as("SELECT * FROM User")
        .fetch_all(&pool)
        .await
        .unwrap();

    println!("{:?}", res);
}

async fn connect() -> Result<MySqlPool, Error> {
    let uri = dotenv::var("DATABASE_URL").unwrap();

    MySqlPool::connect(&uri).await
}

