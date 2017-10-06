using System;
using System.Linq;
using System.Web.UI.WebControls;
using OnTimeDeliveryClassLibrary;
using OnTimeDelivery;
using System.Data;
using System.Collections.Generic;

public partial class OnTimeDeliveries : System.Web.UI.Page
{
    private static DeliverySchedule _deliverySchedule;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Initialize delivery schedule
            _deliverySchedule = new DeliverySchedule();

            txtDepartTime.Focus();

            //Bind vehicle types from class library helpers
            ddlVehicleType.DataSource = Helpers.GetVehicles();
            ddlVehicleType.DataBind();
            ddlVehicleType.SelectedIndex = 0;
        }
    }

    protected void btnAddDelivery_Click(object sender, EventArgs e)
    {
        lblShowScheduleMsg.Style.Add("display", "none");

        //Add to delivery schedule
        if (IsDeliveryValid())
        {        
            try
            {
                Deliveries delivery = new Deliveries
                {
                    TrackingNumber = Guid.NewGuid(),
                    DepartureTime = Convert.ToDateTime(txtDepartTime.Text),

                    TravelDistance = Convert.ToInt32(txtDistance.Text),
                    VehicleType = ddlVehicleType.SelectedItem.Text,
                    TravelTime = Convert.ToDouble(txtTravelTime.Value)
                };
                delivery.DeliveryTime = delivery.DepartureTime.AddHours(delivery.TravelTime);
                _deliverySchedule.Add(delivery);

                lvDeliverySchedule.DataSource = _deliverySchedule;
                lvDeliverySchedule.DataBind();

                pnlDeilverySchedule.Visible = true;

                ResetTimes();
                //Reset add delivery form
                txtDepartTime.Text = "";
                txtDistance.Text = "";
                ddlVehicleType.SelectedIndex = 0;
                txtDepartTime.Focus();

                if (_deliverySchedule.Count > 4)
                    btnShowSchedule.Visible = true;
            }
            catch (Exception ex)
            {
                lblShowScheduleMsg.Text = ex.Message;
            }
        }
        
    }

    protected void btnShowSchedule_Click(object sender, EventArgs e)
    {
        if (IsScheduleValid())
        {
            //Reorder by departure time
            _deliverySchedule.Sort((x, y) => DateTime.Compare(Convert.ToDateTime(x.DepartureTime), Convert.ToDateTime(y.DepartureTime)));
            lvDeliverySchedule.DataSource = _deliverySchedule;
            lvDeliverySchedule.DataBind();

            btnShowSchedule.Visible = false;
            pnlAddDelivery.Visible = false;
            btnAddMoreDeliveries.Visible = true;
        }
    }

    protected void btnCalulateTravelTime_Click(object sender, EventArgs e)
    {
        if (IsDeliveryValid())
        {
            try
            {
                List<Vehicles> vehicles = Helpers.GetVehicles();
                foreach (Vehicles vehicle in vehicles)
                {
                    if (vehicle.VehicleType == ddlVehicleType.SelectedItem.Text)
                    {
                        txtTravelTime.Value = vehicle.CalculateTravelTime(Convert.ToInt32(txtDistance.Text)).ToString("0.00");
                        break;
                    }

                }
                btnAddDelivery.Visible = true;
            }
            catch
            {

            }
        }
    }

    protected void btnAddMoreDeliveries_Click(object sender, EventArgs e)
    {
        pnlAddDelivery.Visible = true;
        btnShowSchedule.Visible = true;
        btnAddMoreDeliveries.Visible = false;
    }

    protected void btnDeleteDelivery_Click(object sender, EventArgs e)
    {
        Button btnDeleteDelivery = (Button)sender;
        ListViewItem lvItem = (ListViewItem)btnDeleteDelivery.NamingContainer;

        _deliverySchedule.RemoveAt(lvItem.DisplayIndex);

        lvDeliverySchedule.DataSource = _deliverySchedule;
        lvDeliverySchedule.DataBind();

        if (lvDeliverySchedule.Items.Count == 0)
            pnlDeilverySchedule.Visible = false;
    }

    protected void ddlVehicleType_SelectedIndexChanged(object sender, EventArgs e)
    {
        ResetTimes();
    }

    private bool IsDeliveryValid()
    {
        bool isValid = true;

        try
        {
            if (!DateTime.TryParse(txtDepartTime.Text, out DateTime dateValue))
            {
                isValid = false;
                txtDepartTime.CssClass = "form-control col-md-2 is-invalid";
            }
            else
                txtDepartTime.CssClass = "form-control col-md-2";

            if (!double.TryParse(txtDistance.Text, out double numberValue) || Convert.ToDouble(txtDistance.Text) <= 0)
            {
                isValid = false;
                txtDistance.CssClass = "form-control col-md-2 is-invalid";
            }
            else
                txtDistance.CssClass = "form-control col-md-2";
        }
        catch
        {
            isValid = false;
        }

        return isValid;
    }

    private void ResetTimes()
    {
        txtDeliveryTime.Value = "";
        txtTravelTime.Value = "";
        btnAddDelivery.Visible = false;
    }

    private bool IsScheduleValid()
    {
        bool isValid = true;

        lblShowScheduleMsg.Style.Add("display", "none");
        lblShowScheduleMsg.Text = "";

        try
        {
            //Check for at least 5 delivery schedules
            if (_deliverySchedule.Count < 4)
            {
                isValid = false;
                lblShowScheduleMsg.Text = "Please enter at least 5 deliveries.";
            }
            else
            {
                //Check for at least 2 vehicle types
                var deliveries = _deliverySchedule.Select(x => x.VehicleType).Distinct();

                if (deliveries.Count() < 2)
                {
                    isValid = false;
                    lblShowScheduleMsg.Text = "Please enter at least 2 different Vehicle Types.";
                }
            }

            if (lblShowScheduleMsg.Text.Length > 0)
                lblShowScheduleMsg.Style.Add("display", "block");
        }
        catch
        { }

        return isValid;
    }
}
