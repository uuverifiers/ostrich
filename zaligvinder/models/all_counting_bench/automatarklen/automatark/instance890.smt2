(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]\w{0,30}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ^(\d{4}[- ]){3}\d{4}|\d{16}$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 16 16) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; horoscope2YAHOOwww\u{2e}2-seek\u{2e}com\u{2f}searchHost\x3A
(assert (not (str.in_re X (str.to_re "horoscope2YAHOOwww.2-seek.com/searchHost:\u{0a}"))))
; \.myway\.comToolbarUI2Host\x3ASubject\x3Atoxbqyosoe\u{2f}cpvm
(assert (str.in_re X (str.to_re ".myway.com\u{1b}ToolbarUI2Host:Subject:toxbqyosoe/cpvm\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
