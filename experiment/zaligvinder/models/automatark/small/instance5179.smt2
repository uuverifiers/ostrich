(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{28}compatible\u{3b}[A-Z]*\u{3b}\u{29}\u{0d}\u{0a}/H
(assert (str.in_re X (re.++ (str.to_re "/(compatible;") (re.* (re.range "A" "Z")) (str.to_re ";)\u{0d}\u{0a}/H\u{0a}"))))
; ^[a-zA-Z]\w{0,30}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}motn/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".motn/i\u{0a}")))))
; User-Agent\x3A\s+GET\d+\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GET") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}")))))
; \x2Frss\d+answer\sHost\x3A
(assert (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}"))))
(check-sat)
