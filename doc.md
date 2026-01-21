# Documentazione API - Gestione Liste e Item

## Panoramica

Questa API fornisce endpoints per la gestione di liste e item associati a una casa (house). Tutti gli endpoints richiedono autenticazione JWT e verificano che l'utente appartenga alla casa associata alle risorse richieste.

## Autenticazione

Tutti gli endpoints richiedono un token JWT valido. Il token deve contenere:
- `uid`: ID univoco dell'utente

Il token viene estratto automaticamente dal middleware e reso disponibile nel contesto come `"data"`.

## Endpoints

### 1. Ottieni tutte le liste

**Endpoint:** `GET /lists`

**Descrizione:** Recupera tutte le liste associate alla casa dell'utente autenticato.

**Headers richiesti:**
- `Authorization: Bearer <token_jwt>`

**Risposta di successo (200):**
```json
{
  "items": [
    {
      "id": "list_id",
      "name": "Nome Lista",
      "house_id": "house_id",
      ...
    }
  ]
}
```

**Errori possibili:**
- `400`: Errore nel recupero dell'utente o delle liste

---

### 2. Crea nuovo item

**Endpoint:** `POST /lists/:id/items`

**Descrizione:** Crea un nuovo item all'interno di una lista specifica.

**Parametri URL:**
- `id`: ID della lista

**Headers richiesti:**
- `Authorization: Bearer <token_jwt>`
- `Content-Type: application/json`

**Body richiesto:**
```json
{
  "text": "Testo dell'item"
}
```

**Validazioni:**
- Il campo `text` deve superare la validazione `list_item_text`
- L'utente deve appartenere alla stessa casa della lista
- La lista deve esistere

**Risposta di successo (200):**
```json
{}
```

**Errori possibili:**
- `400`: JSON malformato, validazione fallita, errore database
- `403`: L'utente non ha accesso alla lista (casa diversa)

**Codici errore specifici:**
- `JsonFormatError`: Dati JSON non validi
- `NotAuthorized`: Tentativo di accesso a liste di altre case

---

### 3. Ottieni items di una lista

**Endpoint:** `GET /lists/:id/items`

**Descrizione:** Recupera tutti gli item di una lista specifica.

**Parametri URL:**
- `id`: ID della lista

**Headers richiesti:**
- `Authorization: Bearer <token_jwt>`

**Risposta di successo (200):**
```json
{
  "items": [
    {
      "id": "item_id",
      "text": "Testo dell'item",
      "list_id": "list_id",
      "created_by": "user_id",
      ...
    }
  ]
}
```

**Errori possibili:**
- `400`: Lista non trovata, errore database
- `403`: L'utente non ha accesso alla lista (casa diversa)

**Codici errore specifici:**
- `NotAuthorized`: Tentativo di accesso a liste di altre case

---

### 4. Aggiorna item

**Endpoint:** `PUT /lists/:id/items/:item_id`

**Descrizione:** Aggiorna il testo di un item esistente.

**Parametri URL:**
- `id`: ID della lista
- `item_id`: ID dell'item da aggiornare

**Headers richiesti:**
- `Authorization: Bearer <token_jwt>`
- `Content-Type: application/json`

**Body richiesto:**
```json
{
  "text": "Nuovo testo dell'item"
}
```

**Validazioni:**
- Il campo `text` deve superare la validazione `list_item_text`
- L'utente deve appartenere alla stessa casa della lista
- La lista deve esistere
- L'item deve appartenere alla lista specificata (verificato lato database)

**Risposta di successo (200):**
```json
{}
```

**Errori possibili:**
- `400`: JSON malformato, validazione fallita, item/lista non trovati
- `403`: L'utente non ha accesso alla lista (casa diversa)

**Codici errore specifici:**
- `JsonFormatError`: Dati JSON non validi
- `NotAuthorized`: Tentativo di accesso a liste di altre case

---

## Modelli di Dati

### ItemInput
```go
type ItemInput struct {
    Text string `json:"text"`
}
```

### DBError
```go
type DBError struct {
    Message   string
    ErrorCode int
}
```

## Note di Sicurezza

1. **Isolamento per casa**: Tutti gli endpoints verificano che l'utente autenticato appartenga alla stessa casa delle risorse richieste
2. **Validazione input**: Il testo degli item viene validato tramite la funzione `checks.Check("list_item_text", ...)`
3. **Autenticazione obbligatoria**: Tutti gli endpoints richiedono un token JWT valido

## Dipendenze

- `gin-gonic/gin`: Framework web
- `golang-jwt/jwt`: Gestione JWT
- Package interni:
  - `checks`: Validazioni
  - `db`: Operazioni database
  - `models`: Modelli dati
