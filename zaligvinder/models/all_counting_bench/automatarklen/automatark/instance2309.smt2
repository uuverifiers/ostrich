(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BTrojan\x3A\w+Host\x3Arprpgbnrppb\u{2f}ci
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:rprpgbnrppb/ci\u{0a}"))))
; (\[url=?"?)([^\]"]*)("?\])([^\[]*)(\[/url\])
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.* (re.comp (str.to_re "["))) (str.to_re "[/url]\u{0a}[url") (re.opt (str.to_re "=")) (re.opt (str.to_re "\u{22}")) (re.opt (str.to_re "\u{22}")) (str.to_re "]"))))
; /^User\x2DAgent\x3A\s*Mozilla\u{0d}?$/smiH
(assert (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Mozilla") (re.opt (str.to_re "\u{0d}")) (str.to_re "/smiH\u{0a}"))))
; /filename=[^\n]*\u{2e}xpm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xpm/i\u{0a}"))))
; [1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z][a-zA-Z])|([sS][bce-rt-xBCE-RT-X]))
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union (re.++ (re.union (re.range "a" "r") (re.range "t" "z") (re.range "A" "R") (re.range "T" "Z")) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "b") (str.to_re "c") (re.range "e" "r") (re.range "t" "x") (str.to_re "B") (str.to_re "C") (re.range "E" "R") (re.range "T" "X")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
