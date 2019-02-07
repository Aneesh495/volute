use crate::event::Event;
use std::collections::VecDeque;

#[derive(Debug, Clone)]
pub enum WindowType {
    Tumbling { size_ms: i64 },
    Sliding { size_ms: i64, slide_ms: i64 },
    Count { count: usize },
}

pub struct WindowBuffer {
    pub window_type: WindowType,
    pub events: VecDeque<Event>,
    pub last_slide_time_ms: i64,
}

impl WindowBuffer {
    pub fn new(window_type: WindowType) -> Self {
        Self {
            window_type,
            events: VecDeque::new(),
            last_slide_time_ms: 0,
        }
    }

    pub fn push(&mut self, event: Event) -> Option<Vec<Event>> {
        match self.window_type {
            WindowType::Count { count } => {
                self.events.push_back(event);
                if self.events.len() >= count {
                    let out: Vec<Event> = self.events.drain(..).collect();
                    Some(out)
                } else {
                    None
                }
            }
            WindowType::Tumbling { size_ms } => {
                let ts_ms = event.timestamp_ns / 1_000_000;
                self.events.push_back(event);
                if self.last_slide_time_ms == 0 {
                    self.last_slide_time_ms = ts_ms;
                }
                if ts_ms - self.last_slide_time_ms >= size_ms {
                    self.last_slide_time_ms = ts_ms;
                    let out: Vec<Event> = self.events.drain(..).collect();
                    Some(out)
                } else {
                    None
                }
            }
            WindowType::Sliding { size_ms, slide_ms } => {
                let ts_ms = event.timestamp_ns / 1_000_000;
                self.events.push_back(event);
                if self.last_slide_time_ms == 0 {
                    self.last_slide_time_ms = ts_ms;
                }
                if ts_ms - self.last_slide_time_ms >= slide_ms {
                    self.last_slide_time_ms = ts_ms;
                    let cutoff = ts_ms - size_ms;
                    while let Some(front) = self.events.front() {
                        if front.timestamp_ns / 1_000_000 < cutoff {
                            self.events.pop_front();
                        } else {
                            break;
                        }
                    }
                    Some(self.events.iter().cloned().collect())
                } else {
                    None
                }
            }
        }
    }
}
