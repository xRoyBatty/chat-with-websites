# JavaScript Updates and Modern Features (2024)

## Core Language Features

### Temporal API
A modern replacement for the Date object:

```javascript
// Creating dates and times
const now = Temporal.Now.instant();
const dateTime = Temporal.Now.plainDateTimeISO();

// Duration and arithmetic
const laterDate = now.add({ days: 7, hours: 12 });
const duration = Temporal.Duration.from({ days: 1, hours: 2 });

// Timezone handling
const tokyoTime = dateTime.withTimeZone('Asia/Tokyo');
```

### Records and Tuples
New immutable data structures:

```javascript
// Record (immutable object)
const user = #{ name: "John", age: 30 };

// Tuple (immutable array)
const coordinates = #[42, 12];

// Deep equality by value
console.log(#{ a: 1 } === #{ a: 1 }); // true
```

### Top-Level Await
Use await outside of async functions:

```javascript
// Direct module-level await
const response = await fetch('/api/data');
const data = await response.json();

// Initialize with retrieved data
initializeApp(data);
```

### Enhanced String Operations
```javascript
// Better Unicode support
const text = "Hello, 世界!";
console.log(text.normalize('NFC').length);

// New string methods
const isMatch = text.isWellFormed();
const fixed = text.toWellFormed();
```

## New Array Methods

### Array Grouping
```javascript
const items = [
  { type: 'fruit', name: 'apple' },
  { type: 'vegetable', name: 'carrot' }
];

// Group by type
const grouped = Object.groupBy(items, (item) => item.type);

// Result:
// {
//   fruit: [{ type: 'fruit', name: 'apple' }],
//   vegetable: [{ type: 'vegetable', name: 'carrot' }]
// }
```

### Array From Async
```javascript
// Create array from async iterable
const asyncNumbers = async function* () {
  yield* [1, 2, 3];
};

const numbers = await Array.fromAsync(asyncNumbers());
```

## Object Features

### Object.hasOwn
Safer property checking:
```javascript
const obj = { prop: undefined };

// New way (preferred)
console.log(Object.hasOwn(obj, 'prop')); // true

// Old way (less safe)
console.log(obj.hasOwnProperty('prop')); // true
```

## Error Handling

### Error Cause
Better error context:
```javascript
try {
  throw new Error('Failed to fetch', {
    cause: {
      code: 'NETWORK_ERROR',
      details: 'Connection timeout'
    }
  });
} catch (error) {
  console.log(error.cause); // Access error context
}
```

## Best Practices

1. Immutability
   - Use Records and Tuples for immutable data
   - Consider Object.freeze for existing objects
   - Implement immutable patterns in state management

2. Performance
   - Use Top-Level Await judiciously
   - Consider bundler implications
   - Profile memory usage with new features

3. Migration Strategy
   - Plan Temporal API adoption carefully
   - Test extensively when replacing Date usage
   - Provide fallbacks for older browsers

## Future Features Watch

1. Pattern Matching
   - Enhanced switch statements
   - Destructuring improvements
   - More powerful matching patterns

2. Decorators
   - Class and method decorators
   - Property decorators
   - Parameter decorators

3. Pipeline Operator
   - Function chaining improvements
   - Better composition syntax
   - Enhanced readability

## Browser Support Notes
- Check TC39 proposals status
- Test in multiple browsers
- Use appropriate polyfills
- Consider transpilation needs