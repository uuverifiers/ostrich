
def func():
  try:
    raise Exception("hhhhhhhhhh")
  finally:
    print("finally")

func()