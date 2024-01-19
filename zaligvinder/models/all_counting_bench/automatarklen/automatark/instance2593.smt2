(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; url\(['"]?([\w\d_\-\. ]+)['"]?\)
(assert (not (str.in_re X (re.++ (str.to_re "url(") (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (re.+ (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ".") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ")\u{0a}")))))
; httphostHost\u{3a}Agent\u{22}
(assert (str.in_re X (str.to_re "httphostHost:Agent\u{22}\u{0a}")))
; /\/MacApp\/\d{2}(-\d{2}){3}(:\d{2}){2}\.png\r\n[^\u{89}]+?\u{89}PNG/Psmi
(assert (not (str.in_re X (re.++ (str.to_re "//MacApp/") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 2 2) (re.++ (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ".png\u{0d}\u{0a}") (re.+ (re.comp (str.to_re "\u{89}"))) (str.to_re "\u{89}PNG/Psmi\u{0a}")))))
; /filename=[^\n]*\u{2e}air/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".air/i\u{0a}")))))
; ^~/[0-9a-zA-Z_][0-9a-zA-Z/_-]*\.[0-9a-zA-Z_-]+$
(assert (not (str.in_re X (re.++ (str.to_re "~/") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
