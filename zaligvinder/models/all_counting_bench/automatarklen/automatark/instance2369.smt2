(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(BG){0,1}([0-9]{9}|[0-9]{10})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "BG")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Port\x2Ebody=ocllceclbhs\u{2f}gthWeComputerLoggerHost\x3Agdvsotuqwsg\u{2f}dxt\.hd^User-Agent\x3A
(assert (not (str.in_re X (str.to_re "Port.body=ocllceclbhs/gthWeComputerLoggerHost:gdvsotuqwsg/dxt.hdUser-Agent:\u{0a}"))))
; ^[\d]{1,}?\.[\d]{2}$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (\$\s*[\d,]+\.\d{2})\b
(assert (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
