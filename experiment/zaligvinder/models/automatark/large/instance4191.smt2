(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\u{3f}dp\u{3d}[A-Z0-9]{50}&cb\u{3d}[0-9]{9}/Ui
(assert (str.in_re X (re.++ (str.to_re "//?dp=") ((_ re.loop 50 50) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cb=") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; toolbarplace\x2Ecom\sUser-Agent\u{3a}\d+\x2Fnewsurfer4\x2Fclient=BysooTBADdcww\x2Edmcast\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "/newsurfer4/client=BysooTBADdcww.dmcast.com\u{0a}"))))
; Host\u{3a}\dATTENTION\x3A[^\n\r]*From\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "ATTENTION:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "From:User-Agent:\u{0a}"))))
; /HTTP\/1.[01]\r\nUser\u{2d}Agent\u{3a}\u{20}[ -~]+\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.info\r\n/
(assert (str.in_re X (re.++ (str.to_re "/HTTP/1") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (str.to_re "\u{0d}\u{0a}User-Agent: ") (re.+ (re.range " " "~")) (str.to_re "\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".info\u{0d}\u{0a}/\u{0a}"))))
(check-sat)
