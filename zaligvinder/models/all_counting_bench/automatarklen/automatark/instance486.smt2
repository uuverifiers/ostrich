(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\s\S]){1,20}([\s\.])
(assert (not (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}")))))
; ToolBar\s+HWAEUser-Agent\x3ATheef2-\>M\x2Ezipbar\-navig\x2Eyandex\x2Eru
(assert (str.in_re X (re.++ (str.to_re "ToolBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAEUser-Agent:Theef2->M.zipbar-navig.yandex.ru\u{0a}"))))
; ^\d{4,}$|^[3-9]\d{2}$|^2[5-9]\d$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (re.range "3" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "5" "9") (re.range "0" "9") (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
