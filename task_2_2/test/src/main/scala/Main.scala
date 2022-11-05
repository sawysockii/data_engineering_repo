import scala.collection.mutable

object Main extends App {
  val str: String = "Hello, Scala!"
  println(str)
  println(str.reverse)
  println(str.replace("c", "k"))
  println(str + " and goodbye python!")

  def one_salary(annual_salary: Double, bonus_percent: Double, annual_compensation: Double): Double = {
    ((annual_salary * ((bonus_percent / 100) + 1) + annual_compensation) / 12) * 0.87
  }
  println(one_salary(3500000, 30, 120000))

  val unit_salaries: mutable.MutableList[Double] = mutable.MutableList(100000.0, 150000.0, 200000.0, 80000.0, 120000.0, 75000.0)

  def deviation_of_mean_salary(annual_salary: Double, bonus_percent: Double, annual_compensation: Double, salaries_list: mutable.MutableList[Double]):Double = {
    one_salary(annual_salary,bonus_percent,annual_compensation)-(salaries_list.sum/salaries_list.size)
  }
  println(deviation_of_mean_salary(3500000, 30, 120000, unit_salaries))

  def add_salary_with_penalty(annual_salary: Double, bonus_percent: Double, annual_compensation: Double, salaries_list: mutable.MutableList[Double], penalty: Double):mutable.MutableList[Double] ={
    val salary = ((annual_salary * ((bonus_percent / 100) + 1) + annual_compensation) / 12) * 0.87
    salaries_list :+ one_salary(annual_salary,bonus_percent,annual_compensation)*penalty
  }
  println(add_salary_with_penalty(3500000, 30, 120000, unit_salaries, 0.5), add_salary_with_penalty(3500000, 30, 120000, unit_salaries, 0.5).max, add_salary_with_penalty(3500000, 30, 120000, unit_salaries, 0.5).min)

  def add_new_workers(number_of_workers: Int, new_workers_salaries: List[Double], salaries_list: mutable.MutableList[Double]): mutable.MutableList[Double] ={
    for(i <- 0 to number_of_workers-1) salaries_list += new_workers_salaries(i)
    salaries_list
  }
  println(add_new_workers(2, List(350000.0, 90000.0), salaries_list = unit_salaries).sortWith(_ < _))

  def num_of_worker_in_list(salaries_list: mutable.MutableList[Double], worker_salary: Double): Int={
    if(salaries_list.contains(worker_salary)) salaries_list.sortWith(_ < _).indexOf(worker_salary)+1
    else {salaries_list += worker_salary; salaries_list.sortWith(_ < _).indexOf(worker_salary)+1}
  }
  println(num_of_worker_in_list(unit_salaries, 130000.0))

  def out_middle_workers(min_salary: Double, max_salary: Double, salaries_list: mutable.MutableList[Double]): List[Int]= {
    (for {i <- 0 to salaries_list.size-1
         if (salaries_list(i) >= min_salary) && (salaries_list(i) <= max_salary)
         } yield i).toList
    }
  println(unit_salaries, "\n", out_middle_workers(150000.0,250000.0,unit_salaries))

  def indexation(salaries_list: mutable.MutableList[Double], indexation_percent: Double): mutable.MutableList[Double] ={
      salaries_list.map(_*((indexation_percent/100)+1))
  }
  println(indexation(unit_salaries, 7))
}