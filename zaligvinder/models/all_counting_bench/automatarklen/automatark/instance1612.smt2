(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TCP\s+Host\u{3a}\x7D\x7Crichfind\x2EcomHost\x3ASubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "TCP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|richfind.comHost:Subject:\u{0a}"))))
; /filename=[^\n]*\u{2e}lzh/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".lzh/i\u{0a}")))))
; EFError\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
; (^(6011)\d{12}$)|(^(65)\d{14}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}65") ((_ re.loop 14 14) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
