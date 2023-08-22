(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\w+Minutes\sHost\x3Awww\x2Eeblocs\x2EcomHost\x3ARunnerHost\u{3a}\x2Ehtml
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Minutes") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:www.eblocs.com\u{1b}Host:RunnerHost:.html\u{0a}")))))
; /\u{2f}Type\u{2f}XRef\u{2f}W\u{5b}[^\u{5d}]*?\d{7,15}/smi
(assert (str.in_re X (re.++ (str.to_re "//Type/XRef/W[") (re.* (re.comp (str.to_re "]"))) ((_ re.loop 7 15) (re.range "0" "9")) (str.to_re "/smi\u{0a}"))))
; [^ _0-9a-zA-Z\$\%\'\-\@\{\}\~\!\#\(\)\&\^]
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "_") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "$") (str.to_re "%") (str.to_re "'") (str.to_re "-") (str.to_re "@") (str.to_re "{") (str.to_re "}") (str.to_re "~") (str.to_re "!") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "&") (str.to_re "^")) (str.to_re "\u{0a}")))))
; ^[A-Z0-9\\-\\&-]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "\u{5c}" "\u{5c}") (str.to_re "&") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; myway\.com\s+SupervisorPalUser-Agent\x3ASearch
(assert (not (str.in_re X (re.++ (str.to_re "myway.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SupervisorPalUser-Agent:Search\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
