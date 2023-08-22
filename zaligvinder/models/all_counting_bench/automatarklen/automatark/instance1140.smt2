(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /GET\s\/[\w-]{64}\sHTTP\/1/
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 64 64) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1/\u{0a}"))))
; /^.{9}[^\u{03}\u{0a}\u{11}\u{10}]/R
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 9 9) re.allchar) (re.union (str.to_re "\u{03}") (str.to_re "\u{0a}") (str.to_re "\u{11}") (str.to_re "\u{10}")) (str.to_re "/R\u{0a}"))))
; Log[^\n\r]*Host\x3A\dHOST\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Log") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.range "0" "9") (str.to_re "HOST:User-Agent:\u{0a}")))))
; forum=From\u{3a}comTencentTravelerBackAtTaCkExplorer
(assert (not (str.in_re X (str.to_re "forum=From:comTencentTravelerBackAtTaCkExplorer\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
